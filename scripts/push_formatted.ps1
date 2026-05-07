#!/usr/bin/env pwsh
# Script to push all formatted files to GitHub fork using Git Data API
# This creates blobs, builds a tree, creates a commit, and updates the ref

param(
    [string]$Token,
    [string]$Owner = "joecos007",
    [string]$Repo = "chrono-time-travel",
    [string]$Branch = "feat/sci-fi-improvements-v3-final"
)

$headers = @{
    "Authorization" = "Bearer $Token"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}
$baseUrl = "https://api.github.com/repos/$Owner/$Repo"

# 1. Get current branch SHA
Write-Host "Getting current branch SHA..."
$ref = Invoke-RestMethod -Uri "$baseUrl/git/refs/heads/$Branch" -Headers $headers
$currentSha = $ref.object.sha
Write-Host "Current SHA: $currentSha"

# 2. Get the current commit's tree
$commit = Invoke-RestMethod -Uri "$baseUrl/git/commits/$currentSha" -Headers $headers
$baseTreeSha = $commit.tree.sha
Write-Host "Base tree SHA: $baseTreeSha"

# 3. Read changed files list 
$changedFiles = Get-Content "c:\chrono-app\changed_files_clean.txt" | Where-Object { $_ -ne '' }
Write-Host "Pushing $($changedFiles.Count) files..."

# 4. Build tree entries
$treeEntries = @()
foreach ($filePath in $changedFiles) {
    $localPath = Join-Path "c:\chrono-app" ($filePath -replace '/','\\')
    $content = Get-Content $localPath -Raw -Encoding UTF8
    
    # Create blob  
    $blobBody = @{ content = $content; encoding = "utf-8" } | ConvertTo-Json -Depth 2
    $blob = Invoke-RestMethod -Uri "$baseUrl/git/blobs" -Method POST -Headers $headers -Body $blobBody -ContentType "application/json"
    
    $treeEntries += @{
        path = $filePath
        mode = "100644"
        type = "blob"
        sha = $blob.sha
    }
    Write-Host "  Created blob for $filePath"
}

# 5. Create new tree 
Write-Host "Creating tree..."
$treeBody = @{
    base_tree = $baseTreeSha
    tree = $treeEntries
} | ConvertTo-Json -Depth 4
$tree = Invoke-RestMethod -Uri "$baseUrl/git/trees" -Method POST -Headers $headers -Body $treeBody -ContentType "application/json"
Write-Host "New tree SHA: $($tree.sha)"

# 6. Create commit
Write-Host "Creating commit..."
$commitBody = @{
    message = "style: auto-format all dart files and fix trailing commas"
    tree = $tree.sha
    parents = @($currentSha)
} | ConvertTo-Json -Depth 3
$newCommit = Invoke-RestMethod -Uri "$baseUrl/git/commits" -Method POST -Headers $headers -Body $commitBody -ContentType "application/json"
Write-Host "New commit SHA: $($newCommit.sha)"

# 7. Update branch ref
Write-Host "Updating branch ref..."
$refBody = @{ sha = $newCommit.sha } | ConvertTo-Json
Invoke-RestMethod -Uri "$baseUrl/git/refs/heads/$Branch" -Method PATCH -Headers $headers -Body $refBody -ContentType "application/json"
Write-Host "Done! Branch updated to $($newCommit.sha)"
