module Upbit
    class PriceInfosService
        def bitcoin_price
            url = "https://api.upbit.com/v1/ticker?markets=KRW-BTC"
            response = HTTParty.get(url)

            if response.code == 200
                ticker_data = response.parsed_response.first
                bitcoin_price = {
                    market: ticker_data['market'],
                    trade_price: ticker_data['trade_price'],
                    high_price: ticker_data['high_price'],
                    low_price: ticker_data['low_price'],
                    timestamp: Time.at(ticker_data['timestamp'] / 1000)
                }

                return bitcoin_price[:trade_price]
            else
                return nil
            end
        end     
    end
end