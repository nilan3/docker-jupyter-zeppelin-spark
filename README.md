# docker-jupyter-zeppelin-spark
docker image for hosting jupyter notebook or zeppelin on your local environment for testing spark applications.

##Usage

```bash
docker run -it --rm --name=spark-notebook -p 7001:7001 --privileged=true --add-host=moby:127.0.0.1 --env SPARK_LOCAL_IP=127.0.0.1 -v $(pwd)/zepplin_conf/zeppelin-env.sh:/zeppelin/conf/zeppelin-env.sh:ro -v $(pwd)/zepplin_conf/zeppelin-site.xml:/zeppelin/conf/zeppelin-site.xml:ro -v $(pwd)/zeppelin_notebook:/zeppelin/notebook nilan3/spark-notebooks:2.4.3-20190710 zeppelin.sh
```
