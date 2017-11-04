# frozen_string_literal: true

# Table that maintains user ids for terms per minute
class SetTable < BaseTable
  def create_statement
    <<-CREATE.freeze
      CREATE TABLE ids_per_term_per_min (
        content TEXT,
        min TIMESTAMP,
        ids SET<int>,
        PRIMARY KEY (min, content))
    CREATE
  end

  def update(terms:, id:, time:)
    batch = @connection.batch do |batch|
      terms.each do |term|
        arguments = { content: term, min: time.min, id: id }
        batch.add(@update_statement, arguments: arguments)
      end
    end
    @connection.execute(batch)
  end

  private

  def update_statement
    @connection.prepare(
      'UPDATE ids_per_term_per_min SET ids = ids + :id WHERE min = :min ' \
      'AND content = :content'
    )
  end
end
