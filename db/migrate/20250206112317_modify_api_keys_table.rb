class ModifyApiKeysTable < ActiveRecord::Migration[7.2]
  def change
    change_table :api_keys do |t|
      # api_key 컬럼 이름을 app_key로 변경
      t.rename :api_key, :app_key

      # access_key와 secret_key의 null 제약 조건 제거
      change_column_null :api_keys, :access_key, true
      change_column_null :api_keys, :secret_key, true
    end
  end
end
