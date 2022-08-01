FROM atlassian/default-image:3
#Make it easier for development
ARG CACHEBUST=1

ENV CYPRESS_CRASH_REPORTS=0
#ENV npm_config_unsafe_perm true
#ENV npm_config_set_user 0

#Copy intended files for build script
WORKDIR /tmp
COPY ./build /tmp/build
RUN chmod -R +x /tmp/build

# Install yarn & e2e libraries for Node
RUN /tmp/build/nodeSetUnsafe.sh && \
    npm install --global yarn && \
    npx playwright install && \
    npm install --global cypress && cypress run --browser chrome && cypress run --browser firefox \
    npm install --global puppeteer && \
    npm install --global selenium-webdriver

#Install pip for Python 3
RUN export PYTHONV=$(python3 -c "exec(\"import sys\nprint(f'{sys.version_info.major}.{sys.version_info.minor}')\")") && \ 
    apt-get update && \
    apt-get install -y --no-install-recommends python${PYTHONV}-distutils && \
    curl https://bootstrap.pypa.io/get-pip.py | python3

#Install Chrome & Firefox
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable firefox

#Install e2e libraries for Python
RUN pip install playwright && \
    pip install pytest-playwright  && \
    playwright install && \
    pip install selenium && \
    pip install pyppeteer && python3 /tmp/build/pyppeteerLaunch.py

RUN DEBIAN_FRONTEND=noninteractive playwright install-deps

RUN rm -rf /tmp/*