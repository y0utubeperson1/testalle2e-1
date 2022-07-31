FROM atlassian/default-image:3
#Make it easier for development
ARG CACHEBUST=1

ENV CYPRESS_CRASH_REPORTS=0

#Copy intended files for build script
WORKDIR /tmp
COPY ./build /tmp/build
RUN chmod -R +x /tmp/build

# Install yarn & Playwright for Node
RUN /tmp/build/nodeSetUnsafe.sh && \
    npm install --global yarn && \
    npx playwright install && \
    npm install --global cypress && \
    npm install --global puppeteer && \
    npm install --global selenium-webdriver

#Install pip for Python 3
RUN export PYTHONV=$(python3 -c "exec(\"import sys\nprint(f'{sys.version_info.major}.{sys.version_info.minor}')\")") && \ 
    apt-get update && \
    apt-get install -y --no-install-recommends python${PYTHONV}-distutils && \
    curl https://bootstrap.pypa.io/get-pip.py | python3

#Install Playwright for Python
RUN pip install playwright && \
    pip install pytest-playwright  && \
    playwright install && \
    pip install selenium

RUN DEBIAN_FRONTEND=noninteractive playwright install-deps

RUN rm -rf /tmp/*