Deploy ReactJS app to Azure Blob Storage through GitHub Actions using Terraform

Create a simple React app
Choose a suitable working folder and then execute the following command in a terminal window to create a ReactJS app named react2az:

npx create-react-app react2az --use-npm
cd react2az 
npm start
The app will display in your default browser as shown below:

![image](https://user-images.githubusercontent.com/74248496/163662039-fff3e585-0b39-407f-bc63-9e700124ba40.png)


Run your application and you should experience the following web page:

![image](https://user-images.githubusercontent.com/74248496/163662054-7b17a3fe-7841-4ba4-8ad3-bef0372dd0c9.png)


Push ReactJS app to GitHub
Note that your application already contains a .gitignore file. This means that the node_modules folder will be excluded for being pushed to GitHub.

Create a local git repo by running the following command in the root of your application:

git init
git add .
git commit -m "1st commit"

Using Terraform a resource group, a storage and a blob container will get created.

Click on "Go to resource".  In the search field, enter the word static then click on "Static website".

![image](https://user-images.githubusercontent.com/74248496/163662101-d6567f37-d381-49db-9f91-6790fb7662cf.png)

Click on enabled

![image](https://user-images.githubusercontent.com/74248496/163662107-40d56540-01bf-4827-a088-ddb6061a97e6.png)


Click on your browser back button, clear the search field, then select "Access keys".

![image](https://user-images.githubusercontent.com/74248496/163662113-925187b5-7022-4a5a-9b32-d213eec491d9.png)


Click on "Show keys", copy the connection string, then temporarily paste it in a a text editor.
GitHub Actions
In GitHub, click on Settings:

![image](https://user-images.githubusercontent.com/74248496/163662125-9f57442f-dc99-4696-a5de-2644d89027e8.png)


Create a key named AZURE_STORAGE then paste the connection string that you previously saved in a text editor. Click on "Add secret".

![image](https://user-images.githubusercontent.com/74248496/163662132-fa880a27-284c-4c20-a865-4edb399c968b.png)


Add all these secrets:

![image](https://user-images.githubusercontent.com/74248496/163662549-5aaea256-19ac-4da8-a8bd-0deddeeee783.png)


After this github actions will run:

![image](https://user-images.githubusercontent.com/74248496/163662147-f09c62bb-6dfe-4d74-9d82-04b998a10cb4.png)


![image](https://user-images.githubusercontent.com/74248496/163662150-ed1191cc-3a48-408e-bc43-f5fec13727c0.png)


Viewing our web application
You must be dying to view the application hosted on Azure. Return to the Azure portal then go to "static websites". The URL for accessing your application is beside "Primary endpoint".

![image](https://user-images.githubusercontent.com/74248496/163662161-5dc1258b-731b-46a8-a2d6-896cfc46d5e8.png)


Visit the primary endpoint URL and you will see that your ReactJS app is happily hosted on Azure:

![image](https://user-images.githubusercontent.com/74248496/163662169-f0ec9501-8bee-40b2-81f0-9b7d9fa281b5.png)
