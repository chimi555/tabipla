# tabipla

<img width="1432" alt="tabipla" src="https://user-images.githubusercontent.com/59429857/76749961-c2ee4b80-67c0-11ea-8772-5d22ed934c30.png">

旅行の計画を立てる際の情報を管理、共有できるサービスです。</br>
しおりとしてPDF出力することも可能です。

## URL

https://www.tabipla.xyz

ヘッダーのテストログインをクリックで、ゲストアカウントとしてログインできます。</br>
ゲストユーザーのみプロフィール情報を編集不可に設定しています。ご了承ください。</br>
非ログイン状態の場合は、旅行プラン検索、閲覧のみ可能です。</br>


## 使用技術

### 環境

* Ruby 2.5.7
* Rails 5.2.4
* postgreSQL 11.6
* Docker/docker-compose
* RSpec
* CircleCIによる自動テスト(RSpec,rubocop)

### インフラ

* AWS(VPC, EC2, RDS for postgreSQL, S3, Route 53, Elastic IP, ALB, ACM)
* Nginx
* Unicorn

### フロント

* SCSS
* Bootstrap4
* JQuery


## アプリケーションの機能

* ユーザー登録/ログイン機能（deviseを使用）
  - プロフィール編集/パスワード編集機能
* 画像アップロード機能（CarrierWave Amazon S3)
  - 画像リサイズ(mini_magick)
  - デフォルト画像の表示
* 旅行プラン 投稿/削除/編集 機能
  - 多階層構造同時投稿
  - 動的フォーム(nested_form_fieldsを使用)
  - タグ付け機能(Toxi法,フロントにはtag-it.jsを使用)
* PDF出力機能（wicked_pdfを使用）
* お気に入り機能（Ajax）
* お気に入りリスト表示
* ユーザーフォロー機能（Ajax）
* ページネーション機能（Kaminariを使用）
* 検索機能（ransackを使用, cuntry_select or キーワードによる複数検索）
* カテゴリータグ別旅行プラン一覧機能
* 管理ユーザー機能（一般ユーザーのアカウントを削除可能）
* テストユーザー機能（guestユーザーとしてログイン可、プロフィール編集不可制限）


## 今後実装予定の機能

issueをご覧ください。

https://github.com/chimi555/triplog/issues