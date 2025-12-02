#!/bin/bash

set -euo pipefail

BRANCH=${1:-main}

#=============================================================================
# リポジトリ情報の取得
#=============================================================================

REMOTE_URL=$(git remote get-url origin 2>/dev/null) || {
  echo "❌ リモート 'origin' が見つかりません"
  exit 1
}

if [[ $REMOTE_URL =~ git@github\.com:(.+)/(.+)\.git ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
elif [[ $REMOTE_URL =~ https://github\.com/(.+)/(.+)\.git ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
elif [[ $REMOTE_URL =~ github\.com[:/](.+)/(.+) ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]%.git}"
else
  echo "❌ GitHubリポジトリを解析できません"
  exit 1
fi

#=============================================================================
# リポジトリの公開状態を確認
#=============================================================================

REPO_INFO=$(gh api "/repos/${OWNER}/${REPO}" 2>/dev/null) || {
  echo "❌ リポジトリ情報を取得できません"
  exit 1
}

IS_PRIVATE=$(echo "$REPO_INFO" | jq -r '.private')

echo "🔐 ブランチ保護設定: ${OWNER}/${REPO} (${BRANCH})"

if [ "$IS_PRIVATE" = "true" ]; then
  echo "⚠️  プライベートリポジトリのため基本保護のみ適用"
  ENABLE_FULL_PROTECTION=false
else
  ENABLE_FULL_PROTECTION=true
fi

#=============================================================================
# 確認
#=============================================================================

read -p "続行しますか？ (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "キャンセル"
  exit 0
fi

#=============================================================================
# ブランチ保護の適用
#=============================================================================

apply_protection() {
  gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    "/repos/${OWNER}/${REPO}/branches/${BRANCH}/protection" \
    --input -
}

if [ "$ENABLE_FULL_PROTECTION" = true ]; then
  apply_protection <<EOF
{
  "required_status_checks": { "strict": true, "contexts": [] },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
  echo "✅ 完了: PR必須、直接プッシュ禁止、管理者バイパス禁止"
else
  apply_protection <<EOF
{
  "required_status_checks": null,
  "enforce_admins": null,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
  echo "✅ 完了: 強制プッシュ・削除禁止（直接プッシュは許可）"
fi

echo "🔗 https://github.com/${OWNER}/${REPO}/settings/branches"
