module Whenever
  module Output
    class Fcron < Cron

    def self.keywords
      @keywords ||= [] # [:hour, :midhour, :day, :midday, :night, :week, :midweek, :month, :midmonth, :mins, :hours, :days, :mons, :dow]
    end

    def self.frequency_regex
      @frequency_regex ||= /^@.*\s+(\d+(m|w|d|h|s)?)+$/
    end

    def self.time_regex
      @time_regex ||= /^&?.*\s+.+\s+.+\s+.+\s+.+\s+.+$/
    end

    def self.periodic_regexes
      @periodic_regexes ||= {
        :one_dimensional => /^%(#{['hourly', 'midhourly'].join '|'}),?.*\s+.+\s+.+$/,
        :two_dimensional => /^%(#{['daily', 'middaily', 'nightly', 'weekly', 'midweekly'].join '|'}),?.*\s+.+\s+.+$/,
        :three_dimensional => /^%(#{['monthly', 'midmonthly'].join '|'}),?.*\s+.+\s+.+\s+.+$/,
        :five_dimensional => /^%(#{['mins', 'hours', 'days', 'mons', 'dow'].join '|'}),?.*\s+.+\s+.+\s+.+\s+.+\s+.+$/
      }
    end

    def self.regex
      @regex ||= Regexp.union(*[frequency_regex, time_regex, periodic_regexes.values].flatten)
    end

    attr_reader :modifier

    def has_modifier?
      ['@', '&', '%'].include?(@time.to_s.first)
    end

    def output
      output = [options, time_in_cron_syntax, task].compact.join(' ').strip
      # Prepend the modifier last
      [modifier, output].join(!modifier || @with.any? ? '' : ' ')
    end

    def options
      @with.join(',')
    end

    protected

      def time_in_cron_syntax
        time_in_cron = super

        case time_in_cron.first
          when '@', '&'
            @modifier = time_in_cron.first
            time_in_cron = time_in_cron[1..-1].strip
          when '%'
            @modifier = "#{time_in_cron[/^%[a-z]+/]},"
            time_in_cron = time_in_cron.sub(/^%[a-z]+/, '').strip
          else
            @modifier = '&'
        end

        time_in_cron
      end

      def parse_as_string
        return unless @time
        string = @time.to_s

        if !has_modifier? && ('@ ' + string) =~ self.class.frequency_regex
          '@ ' + string
        else
          super
        end
      end

      def parse_symbol
        return super if at_given?

        shortcut = case @time
          #when *self.class.keywords then "%#{@time}"
          when :year  then '@ 12m'
          when :day   then '@ 12d'
          when :month then '@ 1m'
          when :week  then '@ 1w'
          when :hour  then '@ 1h'
        end

        if shortcut
          return shortcut
        else
          parse_as_string
        end

      end
    end
  end
end
