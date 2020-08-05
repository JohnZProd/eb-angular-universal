# Angular Universal on EB

This walkthrough will provide a summary of deploying a sample Angular Universal application onto AWS Elastic Beanstalk using an Amazon Linux 1 environment.

For this example, my local environment was running Ubuntu 18.04 LTS

We've also created an Elastic Beanstalk environment named 'angular-app-env' under the Application named 'angular-app'

## Setting Up Local Environment

### Step-by-Step

Install the necessary packages into the local environment (unzip, pip, and awsebcli)

```
sudo apt update
sudo apt install -y unzip
sudo apt install -y python-dev
sudo apt install -y python-pip
pip install awsebcli --upgrade
export PATH=~/.local/bin:$PATH
```
Next, install Node.js - this will install the latest version of Node.js 12
```
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs
```

Download the Angular Universal sample application and setup the application folder

```
curl -O https://angular.io/generated/zips/universal/universal.zip 
unzip universal.zip -d universal/
rm -f universal.zip
mv build.sh universal/
mv .ebextensions/ universal/
```

Alternatively, you can run 
```
sh setup.sh
```

Navigate to the application directory

```
cd universal/
```

## Deployment Options

### Pre-deployment Config

An angular application only really needs the dist/ folder to run on Elastic Beanstalk (or any webserver). This results in a much more lightweight deployment package. If you would like to proceed with this method, you will have to make a minor change to the server.ts file.

```javascript
//server.ts file
const distFolder = join(process.cwd(), 'dist/browser'); //OPTION A - DEFAULT
// OR
const distFolder = join(process.cwd(), 'browser'); //OPTION B
```

Install dependencies and compile the code

```bash
npm install
npm run build:ssr
```

Alternatively, you can run 

```bash
sh build.sh
```

### Option A - Deploy Entire Bundle

If you do not want to make any changes to the code, you will need to deploy the entire bundle for your application to work on Elastic Beanstalk (i.e. the root folder is ~/universal/)

Ensure the following a file named node-config.config is added to .ebextensions/ with the content
```yaml
option_settings:
  aws:elasticbeanstalk:container:nodejs:
    NodeCommand: "node dist/server/main.js"
```

Then, simply deploy the code onto the Elastic Beanstalk environment
```bash
export AWS_ACCESS_KEY_ID=***
export AWS_SECRET_ACCESS_KEY=***
eb init angular-app -r ap-southeast-2
eb deploy angular-app-env
```

### Option B - Deploy dist/ Folder 

Edit the following a file named node-config.config into .ebextensions with the content

```yaml
option_settings:
  aws:elasticbeanstalk:container:nodejs:
    NodeCommand: "node server/main.js"
```

Add package.json and any .ebextensions to the dist folder

```bash
cp -r {package.json,.ebextensions/} dist/
cd dist/
```

Then, simply deploy the code onto the Elastic Beanstalk environment

```bash
export AWS_ACCESS_KEY_ID=***
export AWS_SECRET_ACCESS_KEY=***
eb init angular-app -r ap-southeast-2
eb deploy angular-app-env
```

