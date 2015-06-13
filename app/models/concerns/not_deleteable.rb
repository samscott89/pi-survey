module NotDeleteable

  # Models which inherit this (via include NotDeleteable) wont
  # be deleted on a record.destroy command. Instead they will have the
  # deleted: true attributes set.
  def destroy
    unless self.respond_to? :deleted
      raise MissingMigrationException
    end

    self.update_attribute :deleted, true
  end

  # To really delete a record, then anything which is marked
  # as a deleteable depedent should indeed be destroyed too.
  def delete
    run_callbacks(:destroy) do
      self.destroy
    end
  end

  def self.included(base)
    base.class_eval do
      default_scope {
        where( deleted: false )
      }
    end
  end
end



class MissingMigrationException < Exception
  def message
    "Model is lacking the deleted boolean field for NotDeleteable to work"
  end
end