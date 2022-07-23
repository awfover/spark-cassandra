import os
import sys
import shutil
import subprocess

from pathlib import Path

if __name__ == '__main__':
    src_dir = os.path.abspath(sys.argv[1])
    snapshot_name = sys.argv[2]
    dst_dir = sys.argv[3] if len(sys.argv) >= 4 else os.path.join(
        os.path.dirname(__file__), snapshot_name)
    p = subprocess.run(['find', src_dir, '-d', '-name',
                       snapshot_name], capture_output=True, text=True)

    for src_path in p.stdout.splitlines():
        parts = Path(src_path).parts
        keyspace = parts[-4]
        table = parts[-3].split('-')[0]
        dst_path = os.path.join(dst_dir, keyspace, table)
        if not os.path.exists(dst_path):
            shutil.copytree(src_path, dst_path)
