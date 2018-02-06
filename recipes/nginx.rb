apt_update 'update' if platform_family?('debian')

package 'curl'

include_recipe 'nginx::default'


files= "Anaconda#{node["conda"]["python"]}-#{node["conda"]["version"]}-Linux-x86_64.sh" + ", " +
  "influxdb-#{node['influxdb']['version']}_linux_amd64.tar.gz" + ", " +
  "grafana-#{node['grafana']['version']}.linux-x64.tar.gz" + ", " +
  "telegraf-#{node['telegraf']['version']}_linux_amd64.tar.gz" + ", " +
  "kapacitor-#{node['kapacitor']['version']}_linux_amd64.tar.gz" + ", " +
  "logstash-#{node['logstash']['version']}.tar.gz" + ", " +
  "kibana-#{node['kibana']['version']}-linux-x86_64.tar.gz" + ", " +
  "filebeat-#{node['filebeat']['version']}-linux-x86_64.tar.gz" + ", " +
  "mysql-cluster-gpl-#{node['ndb']['version']}-linux-glibc#{node['ndb']['glib_version']}-x86_64.tar.gz" + ", " +
  "hops-" + node['hops']['version'] + ".tgz" + ", " +
  "ndb-dal-#{node['hops']['version']}-#{node['ndb']['version']}.jar" + ", " +
  "libhopsyarn-#{node['hops']['version']}-#{node['ndb']['version']}.so" + ", " +
  "nvidia-management-#{node['hops']['version']}-#{node['ndb']['version']}.jar" + ", " +
  "libhopsnvml-#{node['hops']['version']}.so" + ", " +
  "hops-#{node['hops']['version']}-#{node['ndb']['version']}.sql" + ", " +
  "livy-server-#{node['livy']['version']}.zip" + ", " +
  "#{node['zeppelin']['name']}.tar.gz" + ", " +
  "zeppelin-hopshive-#{node['zeppelin']['version']}.tar.gz" + ", " +
  "apache-hive-#{node['hive2']['version']}-bin.tar.gz" + ", " +
  "mysql-connector-java-#{node['hive2']['mysql_connector_version']}-bin.jar" + ", " +
  "hivecleaner/#{node['platform']}/hivecleaner-#{node['hive2']['hive_cleaner']['version']}.tar.gz" + ", " +
  "apache-tez-#{node['tez']['version']}.tar.gz" + ", " +
  "spark-#{node['hadoop_spark']['version']}-bin-without-hadoop.tgz" + ", " +
  "flink-" + node['flink']['version'] + "-bin-hadoop" + node['flink']['hadoop_version'] + "-scala_" + node['flink']['scala_version'] + ".tgz" + ", " +
  "epipe/#{node['platform_family']}/epipe-#{node['epipe']['version']}.tar.gz" + ", " +
  "dela/dela-#{node['dela']['version']}.jar" + ", " +
  "kafka_#{node['kkafka']['scala_version']}-#{node['kkafka']['version']}.tgz" + ", " +
  "hops-kafka-authorizer-#{node['kkafka']['authorizer_version']}.jar" + ", " +
  "elasticsearch-#{node['elastic']['version']}.tar.gz" + ", " +
  "dr-elephant-#{node['drelephant']['version']}.zip" + ", " +
  "Python.zip" + ", " +
  "tfspark.zip" + ", " +
  "tensorflow/hops-tensorflow-#{node['tensorflow']['hopstf_version']}.jar" + ", " +
  "cuda_#{node['cuda']['major_version'] + "." + node['cuda']['minor_version'] + "_" + node['cuda']['build_version']}#_linux.run" + ", " +
  "#{node['cuda']['driver_version']}" + ", " +
  "cuda_#{node['cuda']['version_patch']}_linux.run" + ", " +
  "cudnn-#{node['cuda']['major_version']}-linux-x64-v#{node['cudnn']['version']}.tgz" + ", " +
  "bazel-#{node['bazel']['version']}-installer-linux-x86_64.sh" + ", " +
  "payara-#{node['glassfish']['version']}.zip" + ", " +
  node['hopsworks']['cauth_version'] + ", " +
  "hopsworks/#{node['hopsworks']['version']}/hopsworks-web.war" + ", " +
  "hopsworks/#{node['hopsworks']['version']}/hopsworks-ca.war" + ", " +
  "hopsworks/#{node['hopsworks']['version']}/hopsworks-ear.ear" + ", " +
  "flyway-commandline-#{node['hopsworks']['flyway']['version']}-linux-x64.tar.gz" + ", " +
  node['dtrx']['version'] + ", " +
  "swagger-ui-2.2.8.tar.gz" + ", " +
  "chefdk-2.3.1-1.el7.x86_64.rpm" + ", " +
  "l_mpi_2018.0.128.tgz" + ", " +
  "#{node['cuda']['nccl_version']}.txz" + ", " +
  "openmpi/#{node['openmpi']['version']}" + ", " +       
  "bcprov-jdk15on-149.jar"

all = files.split(/\s*,\s*/)

spark_dir = "spark-sql-dependencies"

base="/var/www/html"

# directories="hopsworks/#{node['hopsworks']['version']}, parquet, epipe/debian, epipe/rhel, hivecleaner/ubuntu, hivecleaner/centos, zookeeper-#{node['kzookeeper']['version']}, hops-libndbclient/#{node['ndb']['version']}, #{spark_dir}, dela, tensorflow"
# dirs = directories.split(/\s*,\s*/)

# for d in dirs 

#   directory "#{base}/hopsworks/#{d}" do
#     owner node['setup']['user']
#     group node['setup']['group']
#     mode "770"
#     action :create
#     recursive true
#   end

# end


spark_deps = %w{ parquet-encoding-1.9.0.jar parquet-common-1.9.0.jar parquet-hadoop-1.9.0.jar parquet-jackson-1.9.0.jar parquet-column-1.9.0.jar parquet-format-2.3.1.jar hive-exec-1.2.1.spark2.jar spark-hive_2.11-2.2.0.jar snappy-0.4.jar }

directory "#{base}/#{spark_dir}" do
  recursive true
  mode '0755'
end

for f in spark_deps

  remote_file "#{base}/#{f}" do
    user node['setup']['user']
    group node['setup']['group']
    source node['download_url'] + "/#{spark_dir}/#{f}"
    mode 0755
    action :create_if_missing
  end

end  


for f in all

  directory "#{base}/#{File.dirname(f)}" do
    recursive true
    mode '0755'
  end

  remote_file "#{base}/#{f}" do
    user node['setup']['user']
    group node['setup']['group']
    source node['download_url'] + "/#{f}"
    mode 0755
    action :create_if_missing
  end

end  
