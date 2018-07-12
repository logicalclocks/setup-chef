
package 'curl'

case node['platform_family']
when 'debian'
  apt_update 'update'
when 'rhel'
 Chef::Log.info "REDHAT !!!"
  execute 'yum_update_upgrade' do
   command 'sudo yum update -y'
  end
  yum_package 'openssl-libs'
end


if "#{node['setup']['nginx_skip']}" != "true"
  package 'openssl'
  node.override['nginx']['auth_request']['url'] = "#{node['download_url']}/nginx.tar.gz"
  node.override['nginx']['default_root'] = node['setup']['download_dir']
  node.override['nginx']['port'] = 1880
  include_recipe 'nginx::default'
end

cuda_patches = ""
for i in 1..node['cuda']['num_patches'] do
  patch_version  = node['cuda']['major_version'] + "." + node['cuda']['minor_version'] + ".#{i}"
  patch_url  = "cuda_#{patch_version}_linux.run, "
  cuda_patches = cuda_patches + patch_url
end

files= "Anaconda#{node["conda"]["python"]}-#{node["conda"]["version"]}-Linux-x86_64.sh" + ", " +
       "authbind_2.1.1.tar.gz"  + ", " +
  cuda_patches +
  "zookeeper-#{node['kzookeeper']['version']}/zookeeper-#{node['kzookeeper']['version']}.tar.gz"  + ", " +
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
  "livy-#{node['livy']['version']}.zip" + ", " +
  "#{node['zeppelin']['name']}.tar.gz" + ", " +
  "zeppelin-hopshive-#{node['zeppelin']['version']}.tar.gz" + ", " +
  "apache-hive-#{node['hive2']['version']}-bin.tar.gz" + ", " +
  "mysql-connector-java-#{node['hive2']['mysql_connector_version']}-bin.jar" + ", " +
  "hivecleaner/#{node['platform']}/hivecleaner-#{node['hive2']['hive_cleaner']['version']}.tar.gz" + ", " +
  "apache-tez-#{node['tez']['version']}.tar.gz" + ", " +
  "slider-#{node['slider']['version']}-all.tar.gz" + ", " +
  "spark-#{node['hadoop_spark']['version']}-bin-without-hadoop-with-hive-with-r.tgz" + ", " +
  "flink-" + node['flink']['version'] + "-bin-hadoop" + node['flink']['hadoop_version'] + "-scala_" + node['flink']['scala_version'] + ".tgz" + ", " +
  "epipe/#{node['platform_family']}/epipe-#{node['epipe']['version']}.tar.gz" + ", " +
  "dela/#{node['dela']['version']}/dela.jar" + ", " +
  "kafka_#{node['kkafka']['scala_version']}-#{node['kkafka']['version']}.tgz" + ", " +
  "hops-kafka-authorizer-#{node['kkafka']['authorizer_version']}.jar" + ", " +
  "elasticsearch-#{node['elastic']['version']}.tar.gz" + ", " +
  "dr-elephant-#{node['drelephant']['version']}.zip" + ", " +
  "Python.zip" + ", " +
  "tfspark.zip" + ", " +
  "tensorflow/hops-tensorflow-#{node['tensorflow']['hopstf_version']}.jar" + ", " +
  "tensorflow/mnist.tar.gz" + ", " +
  "cuda_#{node['cuda']['major_version'] + "." + node['cuda']['minor_version'] + "_" + node['cuda']['build_version']}_linux.run" + ", " +
  "#{node['cuda']['driver_version']}" + ", " +
  #"cuda_#{node['cuda']['version_patch']}_linux.run" + ", " +
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
  "tensorflow-graph-hops-#{node['tensorflow']['version']}.tar.gz" + ", " +
  "tensorflow-#{node["tensorflow"]["version"]}-cp36-cp36m-manylinux1_x86_64.whl" + ", " +
  "tensorflow_gpu-#{node["tensorflow"]["version"]}-cp36-cp36m-manylinux1_x86_64.whl" + ", " +
  "tensorflow-#{node["tensorflow"]["version"]}-cp27-cp27mu-manylinux1_x86_64.whl"  + ", " +
  "tensorflow_gpu-#{node["tensorflow"]["version"]}-cp27-cp27mu-manylinux1_x86_64.whl"  + ", " +
  "hive-jdbc-#{node['hive2']['version']}-standalone.jar"  + ", " +
  "hops-util-#{node['hops']['hopsutil_version']}.jar" + ", " +
  "hops-examples-spark-#{node['hops']['hopsexamples_version']}.jar" + ", " +
  "hops-examples-flink-#{node['hops']['hopsexamples_version']}.jar" + ", " +
  "hops-examples-hive-#{node['hops']['hopsexamples_version']}.jar" + ", " +
  "sparkmagic-#{node['jupyter']['sparkmagic']['version']}.tar.gz" + ", " +
  "bcprov-jdk15on-149.jar"

all = files.split(/\s*,\s*/)

spark_dir = "spark-sql-dependencies"

base = node['setup']['download_dir']

directory "#{base}" do
  owner node['setup']['user']
  group node['setup']['group']
  mode "775"
  action :create
  recursive true
  not_if { ::Dir.exists?("#{base}") }
end



spark_deps = "parquet-encoding-#{node['hadoop_spark']['parquet_version']}.jar, parquet-common-#{node['hadoop_spark']['parquet_version']}.jar, parquet-hadoop-#{node['hadoop_spark']['parquet_version']}.jar, parquet-jackson-#{node['hadoop_spark']['parquet_version']}.jar, parquet-column-#{node['hadoop_spark']['parquet_version']}.jar, parquet-format-2.3.1.jar, hive-exec-1.2.1.spark2.jar, spark-hive_#{node['scala']['version']}-#{node['hadoop_spark']['version']}.jar, snappy-0.4.jar"

directory "#{base}/#{spark_dir}" do
  recursive true
  mode '0755'
end

deps = spark_deps.split(/\s*,\s*/)

for f in deps

  remote_file "#{base}/#{spark_dir}/#{f}" do
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

remote_file "#{base}/schema.sql" do
  source "https://raw.githubusercontent.com/hopshadoop/hops-metadata-dal-impl-ndb/master/schema/schema.sql"
  owner node['setup']['user']
  mode 0755
  action :create
end

versions = node['hops']['versions'].split(/\s*,\s*/)
previous_version=""
if versions.any?
   previous_version=versions.last
end

prev="2.8.2.1"
for version in versions do
  remote_file "#{base}/update-schema_#{prev}_to_#{version}.sql" do
    source "https://raw.githubusercontent.com/hopshadoop/hops-metadata-dal-impl-ndb/master/schema/update-schema_#{prev}_to_#{version}.sql"
    owner node['setup']['user']
    mode 0755
    action :create
  end
  prev=version
end

remote_file "#{base}/update-schema_#{prev}_to_#{node['hops']['version']}.sql" do
  source "https://raw.githubusercontent.com/hopshadoop/hops-metadata-dal-impl-ndb/master/schema/update-schema_#{prev}_to_#{node['hops']['version']}.sql"
  owner node['setup']['user']
  mode 0755
  action :create
end
