#!/bin/bash
# jclear.sh - 清理特定作业脚本

# 检查并清理所有jjob相关的作业
echo "开始清理所有jjob作业..."

# 查找所有包含jjob的作业ID
if command -v jjobs >/dev/null 2>&1; then
    # 获取所有jjob作业
    JOB_IDS=$(jjobs -a 2>&1 | grep -E "(jjob1|jjob2)" | awk '{print $1}' | head -10)
    
    if [ -n "$JOB_IDS" ]; then
        for job_id in $JOB_IDS; do
            if [ -n "$job_id" ]; then
                echo "正在清理作业 $job_id..."
                
                # 检查作业状态并终止
                STATUS=$(jjobs -w $job_id 2>/dev/null | awk 'NR>1 {print $3}' 2>/dev/null)
                if [ "$STATUS" = "RUN" ] || [ "$STATUS" = "PEND" ]; then
                    echo "正在终止作业 $job_id..."
                    jctrl kill -f $job_id 2>/dev/null
                fi
                
                # 清理作业记录
                jctrl clean $job_id 2>/dev/null
                echo "作业 $job_id 已清理"
            fi
        done
    else
        echo "未找到jjob相关作业"
    fi
else
    echo "jjobs命令不可用，跳过作业清理"
fi

# 删除作业ID文件和数据文件（避免错误提示）
rm -f job_id.txt 2>/dev/null || true
rm -r jdata_* 2>/dev/null || true

echo "所有作业清理完成"
