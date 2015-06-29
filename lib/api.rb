class API < Grape::API
  # applicationControllerに本ファイルを読み込むように記載
  # routes.rmにAPIのルーティングをマウント

  # APIアクセスに接頭辞を付加
  # ex) http://localhost:3000/api
  prefix "api"
  format :json

  # APIアクセスにバージョン情報を付加
  # ex) http://localhost:3000/api/v1
  version 'v1', :using => :path

  resource "users" do

    # # 確認用
    # # ex) curl http://localhost:3000/api/v1/users
    # desc "returns all users"
    # params do
    #   requires :id, type: Integer
    # end
    # get ':id' do
    #   user = User.find(params[:id])
    #   {'userId' => user.id, 'rentSts' => user.rentsts}
    # end
    
    #コマンド curl http://localhost:3000/api/v1/users -X POST -d "id=1" -d "email=example@railstutorial.jp" -d "sts=1"
    desc "return a user"
    # パラメータの定義
    params do
      # requires => 必須パラメータ、optional => 必須じゃない
      requires :id, type: Integer
      requires :email, type: String
      # 貸出要求:1 返却要求:2
      requires :sts, type: Integer
    end
    post do
      # ユーザ情報の取得
      user =  User.find(params[:id])

      # ユーザ認証
      # 暗号化した文字列を複合して認証できればなおよい
      if user.email == params[:email] then
        authResult = 1
      else
        authResult = 0
      end

      # パラメータチェック
      unless params[:sts] == 0 || params[:sts] == 1
        authResult = 0
      end

      #貸出ステータスの更新(
      if authResult == 1
        user.update!(:rentsts => params[:sts].to_i)
      end

      #JSONの返却
      {'userId' => user.id , 'email' => user.email , 'authResult' => authResult , 'rentsts' => user.rentsts}
    end
  end
end