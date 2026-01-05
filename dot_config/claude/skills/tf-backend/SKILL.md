---
name: create-terraform-backend
description: terraform のtfstateファイルの保存先にS3を指定する
---

# Create Terraform Backend

terraform のtfstateファイルの保存先にS3を指定する

## When to Use

ユーザからterraform コードの作成指示があった場合

## TODO

- ユーザに `PROJECT_NAME` を何にするか聞く。今作業しているディレクトリ名を提案する。
- @backend.tf.template を使用し、`PROJECT_NAME` を埋め込んだ backend.tf を生成する。
- 既存 backend.tf がテンプレートと異なる場合は差分だけ最小限で修正

## Response to User

```
✅ terraform backend.tf の整備が完了しました。
```
