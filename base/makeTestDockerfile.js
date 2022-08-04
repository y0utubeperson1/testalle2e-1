const fs = require('fs/promises');
const base = process.env.BASE_IMG;

(async () => {

try {
    const content = `
FROM ${base}
ENV CI true

RUN yarn init -y && yarn create playwright --quiet --lang=js && yarn playwright test
`;
    await fs.writeFile('/tmp/Dockerfile', content);
    } catch (err) {
    throw err;
    }

})();
