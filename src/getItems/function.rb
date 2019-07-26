require "aws-sdk"

def handler(event:, context:)
  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"] # get the table name from the automatically populated environment variables

  params = {
    table_name: table_name,
    item: {
      "id" => "1", # modify with each invoke so the id does not repeat
      "content" => "This is my content" # modify content here
    }, 
    return_consumed_capacity: "TOTAL",
    condition_expression: "attribute_not_exists(id)" # do not overwrite existing entries
  }

  begin
    # Write a new item to the Items table
    dynamodb.put_item(params)
    item_id = params[:item]["id"]
    puts "Writing item #{item_id} to table #{table_name}."

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error writing to table #{table_name}. Make sure this function is running in the same environment as the table."
    puts "#{error.message}"
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": "Success!"
  }

  return response
end
