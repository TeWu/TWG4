ActiveRecord::Base.send(:include, TWG4::ActiveRecordExtensions)
ActionController::Base.send(:include, TWG4::Authentication::ControllerExtensions)
