# tabipla

https://tabipla.xyz

<img width="1432" alt="tabipla" src="https://user-images.githubusercontent.com/59429857/76749961-c2ee4b80-67c0-11ea-8772-5d22ed934c30.png">


旅行の計画を立てる際の情報を管理、共有できるサービスです。
登録ユーザーは、
  旅行計画のログの管理
  PDFによるしおりの出力
  他ユーザーの旅行プランの閲覧&行きたいリストに追加
が可能です。

## 使用技術

### 環境

* Ruby2.5.7
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

* SASS
* Bootstrap4
* JQuery

## アプリケーションの機能

* ユーザー登録/ログイン機能（deviseを使用）
* プロフィール編集/パスワード編集機能
* 画像アップロード機能（CarrierWave Amazon S3)
    画像リサイズ(mini_magick)
* 旅行プラン 投稿/削除/編集 機能
    多階層構造
    動的フォーム(nested_form_fieldsを使用)
    タグ付け機能(Toxi法,フロントにはtag-it.jsを使用)
* PDF書き出し機能（wicked_pdfを使用）
* お気に入り機能（Ajax）
* お気に入りリスト表示
* ユーザーフォロー機能（Ajax）
* ページネーション機能（Kaminariを使用）
* ユーザー登録/ログイン機能（deviseを使用）
* プロフィール編集/パスワード編集機能
* 検索機能（ransackを使用 cuntry_select、キーワードによる複数検索）
* カテゴリータグ別旅行プラン一覧機能
* 管理ユーザー機能（一般ユーザーのアカウントを削除可能）
* テストユーザー機能（プロフィール編集不可制限）
