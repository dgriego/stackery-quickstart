require 'aws-sdk'

def handler(event:, context:)
  # { event: JSON.generate(event), context: JSON.generate(context.inspect) }
  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"]

  begin
    # Use dynamodb to get items from the Items table
    result = dynamodb.scan({
      table_name: table_name,
    })
    result_count = result[:scanned_count]

    result[:items].each do |item|
      item_id = item["id"]
      content = item["content"]
      puts "Item #{item_id}: #{content}"
    end

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error fetching table #{table_name}. Make sure this function is running in the same environment as the table."
    puts "#{error.message}"
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": "#{result_count} items found"
  }

  return response
end
