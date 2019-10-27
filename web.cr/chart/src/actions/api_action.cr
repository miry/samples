# Include modules and add methods that are for all API requests
abstract class ApiAction < Lucky::Action
  accepted_formats [:json]
end
