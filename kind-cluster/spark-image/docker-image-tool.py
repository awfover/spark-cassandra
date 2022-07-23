import os
import json
import subprocess
import shutil
import hashlib

if __name__ == '__main__':
    pwd = os.path.dirname(__file__)
    checksum_file = os.path.join(pwd, 'checksums')

    try:
        with open(checksum_file, 'r') as f:
            checksums = json.load(f)
    except:
        checksums = {}

    jar_dir = os.path.join(pwd, 'jars')
    if os.path.exists(jar_dir):
        shutil.rmtree(jar_dir)

    os.mkdir(jar_dir)

    os.listdir()

    src_dirs = [
        '/Users/awfover/Projects/spark-cassandra-connector/connector/target/scala-2.12/jars',
        '/Users/awfover/Projects/spark/assembly/target/scala-2.12/jars'
    ]

    def should_update(file):
        name = os.path.basename(file)
        checksum = hashlib.md5(open(file, 'rb').read()).hexdigest()
        if name in checksums and checksums[name] == checksum:
            return False

        checksums[name] = checksum
        return True

    for src_dir in src_dirs:
        for name in os.listdir(src_dir):
            if name.endswith('.jar'):
                file = os.path.join(src_dir, name)
                if os.path.isfile(file):
                    if should_update(file):
                        target = os.path.join(jar_dir, name)
                        shutil.copy(file, target)
                        print(f'update jar {name}')

    with open(checksum_file, 'w') as f:
        json.dump(checksums, f)

    subprocess.run(f'cp {pwd}/../start-spark-sql.sh {pwd}'.split(' '))

    subprocess.run(
        f'docker build -t localhost:5000/spark-cassandra:local {pwd}'.split(
            ' ')
    )

    subprocess.run(
        'docker push localhost:5000/spark-cassandra:local'.split(' ')
    )
