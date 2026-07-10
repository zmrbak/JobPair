#!/bin/bash

# jtest.sh - 测试任务启动脚本

# 启动任务
echo "提交作业..."
JOB_FILE="master.job"
SUBMIT_OUTPUT=$(jsub -r < "$JOB_FILE" 2>&1)
echo "$SUBMIT_OUTPUT"

# 提取作业号（假设作业号在输出中）
if [[ "$SUBMIT_OUTPUT" =~ job[[:space:]]+([0-9]+) ]]; then
    JOB_ID="${BASH_REMATCH[1]}"
    echo "作业号: $JOB_ID"
    # 保存作业ID到文件
    echo "$JOB_ID" > job_id.txt
elif [[ "$SUBMIT_OUTPUT" =~ ([0-9]+) ]]; then
    JOB_ID="${BASH_REMATCH[1]}"
    echo "作业号: $JOB_ID"
    # 保存作业ID到文件
    echo "$JOB_ID" > job_id.txt
fi
