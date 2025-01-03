# lib/tasks/poller.rake
# rake poller:fetch_price
namespace :poller do
    desc "Fetch BTC price from Upbit and check trades."
    task fetch_price: :environment do
      FetchPriceJob.perform_now
    end
  end
  