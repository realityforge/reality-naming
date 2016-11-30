#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Reality
  module Naming

    class << self
      def camelize?(word)
        camelize(word) == word
      end

      def camelize(input_word)
        word_parts = split_into_words(input_word).collect { |part| part[0...1].upcase + part[1..-1] }
        return word_parts[0].downcase if (word_parts.size == 1 && word_parts[0] == word_parts[0].upcase)
        word = word_parts.join('')
        word[0...1].downcase + word[1..-1]
      end

      def pascal_case?(word)
        pascal_case(word) == word
      end

      def pascal_case(word)
        word_parts = split_into_words(word).collect { |part| part[0...1].upcase + part[1..-1] }
        return word_parts[0] if (word_parts.size == 1 && word_parts[0] == word_parts[0].upcase)
        word_parts.join('')
      end

      def underscore?(word)
        underscore(word) == word
      end

      def underscore(input_word)
        split_into_words(input_word).join('_').downcase
      end

      def xmlize?(word)
        xmlize(word) == word
      end

      def xmlize(word)
        underscore(word).tr('_', '-')
      end

      def jsonize?(word)
        jsonize(word) == word
      end

      def jsonize(word)
        camelize(word)
      end

      def uppercase_constantize?(word)
        uppercase_constantize(word) == word
      end

      def uppercase_constantize(word)
        underscore(word).upcase
      end

      def pluralize(string)
        singular = string.to_s
        length = singular.size
        last_ch = last(singular)
        last_2ch = last(singular, 2)

        plural = nil
        pluralization_rules.each do |rule|
          plural = rule.call(singular)
          break unless plural.nil?
        end
        if plural.nil?
          if last_ch == 'y'
            plural = "#{singular[0, length - 1]}ies" unless singular =~ /[aeiou]y$/
          elsif last_ch == 'f'
            plural = "#{singular[0, length - 1]}ves" unless singular =~ /[aeiou][aeiou]f$/
          elsif last_2ch == 'fe'
            plural = "#{singular[0, length - 2]}ves"
          elsif %w(ch sh).include?(last_2ch)
            plural = "#{singular[0, length - 2]}es"
          elsif %w(s x z).include?(last_ch)
            plural = "#{singular[0, length - 1]}es"
          end
        end
        plural || "#{singular}s"
      end

      def add_pluralization_rule(&block)
        pluralization_rules << block
      end

      def clear_pluralization_rules
        pluralization_rules.clear
      end

      def split_into_words(word)
        word = word.to_s.dup
        word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!('-', '_')
        word.split('_').collect{|w| w.upcase == w ? w.downcase : w }
      end

      private

      def pluralization_rules
        @pluralization_rules ||= []
      end

      def last(s, limit = 1)
        return s if limit > s.size
        s[-limit, limit]
      end
    end
  end
end
