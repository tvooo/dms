namespace :dms do
  desc "Scan DMS_ROOT for new/changed files and enqueue indexing for each"
  task scan: :environment do
    InitialScanJob.perform_now
  end
end
