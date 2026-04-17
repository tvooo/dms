Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"
end
