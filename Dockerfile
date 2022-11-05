FROM ubuntu:14.04 

# Comment
RUN echo 'cotenedor mysql Darwin Felipe Uzcateguie # excelente'


RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y mysql-server

ADD myconfiguracion.cnf /etc/mysql/conf.d/my.cnf 
ADD ejecutar.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

CMD ["/usr/local/bin/script.sh"]