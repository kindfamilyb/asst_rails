module Upbit
    class PackageService
        # def initialize(package_id: nil, user_id: nil)
        #     @package = Package.find(package_id)
        #     @user = User.find(user_id)
        # end

        # 패키지 정보 조회해서 my_strategy_infos 테이블에 동일한 전략 생성
        def create_my_strategy_infos(package_id: nil, user_id: nil)
            @package = Package.find(package_id)
            package_infos = @package.package_infos
            package_infos.each do |package_info|
                MyStrategyInfo.create(
                    user_id: user_id,
                    strategy_id: package_info.strategy_id,
                    active_yn: "N",
                    exposure_yn: "N",
                    delete_yn: "N",
                    target_profit_rate: package_info.target_profit_rate,
                    trade_account_rate: package_info.trade_account_rate,
                    trade_delay_duration: package_info.trade_delay_duration,
                    trade_delay_type: package_info.trade_delay_type,
                    trade_type: package_info.trade_type,
                    asst_name: package_info.asst_name,
                    package_id: package_id
                )
            end
        end
    end
end