#卸载旧版本
#较旧版本的Docker被称为docker或docker-engine。 如果已安装这些，请卸载它们以及相关的依赖项。
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

#要安装特定版本的Docker CE，请列出repo中的可用版本，然后选择并安装：           
yum list docker-ce --showduplicates | sort -r

#通过其完全限定的包名称安装特定版本，包名称（docker-ce）加上版本字符串（第2列）直到第一个连字符，用连字符（ - ）分隔，例如，docker-ce-18.03.0.ce.
sudo yum install docker-ce-<VERSION STRING>
