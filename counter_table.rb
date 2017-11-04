# frozen_string_literal: true

# Table that maintains counts for terms per minute
class CounterTable < BaseTable
  def create_statement
    <<-CREATE.freeze
      CREATE TABLE terms_per_min (
        content TEXT,
        min TIMESTAMP,
        hour TIMESTAMP,
        count COUNTER,
        PRIMARY KEY (hour, min, content))
    CREATE
  end

  def update(terms:, time:)
    batch = @connection.counter_batch do |batch|
      terms.each do |term|
        arguments = { content: term, min: time.min, hour: time.hour }
        batch.add(@update_statement, arguments: arguments)
      end
    end
    @connection.execute(batch)
  end

  private

  def update_statement
    @connection.prepare(
      'UPDATE terms_per_min SET count = count + 1 WHERE ' \
      'hour = :hour AND min = :min AND content = :content'
    )
  end
end
