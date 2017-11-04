module Users
  def self.instances
    @instances ||= [Hipster, TwinPeaks, Simpsons, Seinfled].map do |klass|
      klass.send(:new)
    end
  end

  class Hipster
    def id
      1
    end

    def text
      Faker::Hipster.sentence
    end
  end

  class TwinPeaks
    def id
      2
    end

    def text
      Faker::TwinPeaks.quote
    end
  end

  class Simpsons
    def id
      3
    end

    def text
      Faker::Simpsons.quote
    end
  end

  class Seinfled
    def id
      4
    end

    def text
      Faker::Seinfeld.quote
    end
  end
end
