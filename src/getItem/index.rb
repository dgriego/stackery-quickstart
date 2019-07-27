require 'aws-sdk'
require 'json'

def handler(event:, context:)
  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"]
  reqBody = JSON.parse event.body

  begin
    # Use dynamodb to get items from the Items table
    result = dynamodb.get_item({
      table_name: table_name,
      key: {
        id: "1"
      }
    })
  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error fetching table #{table_name}. Make sure this function is running in the same environment as the table."
    puts "#{error.message}"
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": result
  }

  return response
end
