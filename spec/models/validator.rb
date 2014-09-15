require 'active_record'

class Validator < ActiveRecord::Base
  include AASM

  aasm :column => :status do
    state :sleeping, :initial => true
    state :awake
    state :running
    state :failed, :after_enter => :fail

    event :run, :after_commit => :change_name! do
      transitions :to => :running, :from => :sleeping
    end

    event :sleep do
      after_commit { append_name!(' slept') }

      transitions :to => :sleeping, :from => [:running, :awake]
    end

    event :wake do
      after_commit { |description| append_name!(" awoke#{description}") }

      transitions :to => :awake, :from => [:sleeping]
    end

    event :fail do
      transitions :to => :failed, :from => [:sleeping, :running, :awake]
    end
  end

  validates_presence_of :name

  def append_name!(suffix)
    self.name += suffix
    save!
  end

  def change_name!
    self.name = 'name changed'
    save!
  end

  def fail
    raise StandardError.new('failed on purpose')
  end
end

class MultipleValidator < ActiveRecord::Base
  include AASM

  aasm :left, :column => :status do
    state :sleeping, :initial => true
    state :awake
    state :running
    state :failed, :after_enter => :fail

    event :run, :after_commit => :change_name! do
      transitions :to => :running, :from => :sleeping
    end

    event :sleep do
      after_commit { append_name!(' slept') }

      transitions :to => :sleeping, :from => [:running, :awake]
    end

    event :wake do
      after_commit { |description| append_name!(" awoke#{description}") }

      transitions :to => :awake, :from => [:sleeping]
    end

    event :fail do
      transitions :to => :failed, :from => [:sleeping, :running, :awake]
    end
  end

  validates_presence_of :name

  def append_name!(suffix)
    self.name += suffix
    save!
  end

  def change_name!
    self.name = 'name changed'
    save!
  end

  def fail
    raise StandardError.new('failed on purpose')
  end
end
