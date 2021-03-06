require 'puppet/util/pidlock'

# Break out the code related to locking the agent.  This module is just
# included into the agent, but having it here makes it easier to test.
module Puppet::Agent::Locker
  # Yield if we get a lock, else do nothing.  Return
  # true/false depending on whether we get the lock.
  def lock
    if lockfile.lock
      begin
        yield
      ensure
        lockfile.unlock
      end
    end
  end

  def lockfile
    @lockfile ||= Puppet::Util::Pidlock.new(lockfile_path)

    @lockfile
  end

  def running?
    lockfile.locked?
  end
end
