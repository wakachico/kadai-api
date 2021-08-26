# テーブル定義

## categories テーブル
アイデアのカテゴリーを保存するテーブル
| Column            | Type    | Options                   |
| ----------------- | ------- | ------------------------- |
| name              | string  | null: false, unique: true |

### Association

- has_many :ideas

## ideas テーブル 
アイデアを保存するテーブル

| Column    | Type        | Options                         |
| --------- | ----------- | ------------------------------- |
| body      | text        | null: false                     |
| category  | references  | null: false, foreign_key: true  |

### Association

- belongs_to :category