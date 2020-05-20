module Yolk
  module Models
    class User
      def initialize(hash = {})
        attributes = hash.with_indifferent_access
        @first_name = attributes[:first_name]
        @last_name = attributes[:last_name]
        @display_name = attributes[:display_name]
        @username = attributes[:username]
        @email = attributes[:email]
        @student_id = attributes[:student_id]
        @id = attributes[:id]
        @token = attributes[:token]
        @groups = attributes[:groups]
      end

      def display_name
        @display_name
      end
      def display_name=(val)
        mark_dirty unless val == @display_name
        @display_name = val
      end

      def first_name
        @first_name
      end
      def first_name=(val)
        mark_dirty unless val == @first_name
        @first_name = val
      end

      def last_name
        @last_name
      end
      def last_name=(val)
        mark_dirty unless val == @last_name
        @last_name = val
      end

      def username
        @username || id || email
      end
      def username=(val)
        mark_dirty unless val == @username
        @username = val
      end

      def email
        @email
      end
      def email=(val)
        mark_dirty unless val == @email
        @email = val
      end

      def student_id
        @student_id
      end
      def student_id=(val)
        mark_dirty unless val == @student_id
        @student_id = val
      end

      def id
        @id
      end
      def id=(val)
        mark_dirty unless val == @id
        @id = val
      end

      def token
        @token
      end

      def groups
        @groups
      end

      def is_dirty?
        !!@is_dirty
      end
      def mark_dirty
        @is_dirty = true
      end

      def to_h
        {
          :first_name => first_name,
          :last_name => last_name,
          :display_name => display_name,
          :username => username,
          :email => email,
          :student_id => student_id,
          :id => id
        }
      end
    end
  end
end
