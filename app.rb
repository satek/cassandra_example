require 'cassandra'

# Main runner class
class App
  include Cassandra::Types

  MessageTime = Struct.new(:hour, :min)

  KEYSPACE = 'cassandra_example'.freeze

  KEYSPACE_DEFINITION = <<-KEYSPACE_CQL.freeze
    CREATE KEYSPACE #{KEYSPACE}
    WITH replication = {
      'class': 'SimpleStrategy',
      'replication_factor': 1
    }
  KEYSPACE_CQL

  def initialize
    session = init_session
    @counter_table = CounterTable.new(session)
    @set_table = SetTable.new(session)
  end

  def run
    @counter_table.create
    @set_table.create
    messages.each do |message|
      terms = message[:text].split
      time = current_time
      @counter_table.update(terms: terms, time: time)
      @set_table.update(terms: terms,
                        id: set(int).new(message[:user_id]),
                        time: time)
    end
  end

  private

  # just produces an endless stream of user messages until the script is killed
  def messages
    return to_enum(__callee__) unless block_given?
    loop do
      user = Users.instances.sample
      message = { user_id: user.id, text: user.text }
      yield message
    end
  end

  def current_time
    time = ::Time.now.utc
    hour = ::Time.new(time.year, time.month, time.day, time.hour)
    min = ::Time.new(time.year, time.month, time.day, time.hour, time.min)
    MessageTime.new(hour, min)
  end

  def init_session
    cluster = Cassandra.cluster
    cluster.connect(KEYSPACE)
  rescue Cassandra::Errors::InvalidError
    cluster.connect('system').execute(KEYSPACE_DEFINITION)
    cluster.connect(KEYSPACE)
  end
end
