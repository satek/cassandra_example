# frozen_string_literal: true

# Base for SetTable and CounterTable
class BaseTable
  def initialize(connection)
    @connection = connection
    create
    @update_statement = update_statement
  end

  def create
    @connection.execute(create_statement)
  rescue Cassandra::Errors::AlreadyExistsError
    nil
  end

  def update_statement
    raise 'Implement in child class'
  end
end
