class ScansController < ApplicationController
  def create
    InitialScanJob.perform_later
    redirect_back fallback_location: root_path, notice: "Scan enqueued."
  end
end
