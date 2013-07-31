ifeq ($(origin JAVA_HOME), undefined)
  ifneq (,$(findstring Darwin,$(shell uname)))
    JAVA_HOME=`/usr/libexec/java_home -F -v1.7*`
  else
    JAVA_HOME=/usr
  endif
endif

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
  COLON=\;
else
  COLON=:
endif

ifeq ($(origin SCALA_JAR), undefined)
  SCALA_JAR=$(NETLOGO)/lib/scala-library.jar
endif

SRCS=$(wildcard src/*.java)

profiler.jar: $(SRCS) manifest.txt NetLogoHeadless.jar
	mkdir -p classes
	$(JAVA_HOME)/bin/javac -g -Werror -encoding us-ascii -source 1.7 -target 1.7 -classpath "NetLogoHeadless.jar$(COLON)$(SCALA_JAR)" -d classes $(SRCS)
	jar cmf manifest.txt profiler.jar -C classes .

NetLogoHeadless.jar:
	curl -f -s -S 'http://ccl.northwestern.edu/devel/NetLogoHeadless-e2bba9de.jar' -o NetLogoHeadless.jar

profiler.zip: profiler.jar
	rm -rf profiler
	mkdir profiler
	cp -rp profiler.jar README.md Makefile src manifest.txt profiler
	zip -rv profiler.zip profiler
	rm -rf profiler
