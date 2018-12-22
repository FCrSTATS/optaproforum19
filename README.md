# Dev-Log for Opta Pro Forum 2019 Presentation

### November 

### December 1 - 14 

###### 1 dec 
Created the plots and created a custom colour scale to represent time, this was constructured from R colour spectrum which I had had limited exposure to prior: 

![alt text](http://research.stowers.org/mcm/efg/R/Color/Chart/ColorsChart1.jpg)

###### 6 Dec 
Got confirmation from Ryan than I can use different slide designs including this one: 
cid:image002.png@01D48D97.5FC5E590

### December 15 - 31

###### 15 Dec 
Worked out how to copy files direct to s3 from terminal -> https://qiita.com/alokrawat050/items/56820afdb6968deec6a2

###### 17 Dec 
Good motivation having received some good feedback from Marek on the overall concept

###### 20 Dec 
Tried switching to Collabotory and loading files via Google Drive to overcome the issue of s3 access in AWS. Interesting to find out free GPU and TPU access with Collab but found that I ran out of memory very quickly and couldn't really run the analysis so I gave up and decided to revert to AWS the next day.

###### 21 Dec 
Trying to get the EC2 instance connected with my S3 storage in order to copy all of the image data across to the instance for processing. Solution is mainly this -> https://optimalbi.com/blog/2016/07/12/aws-tips-and-tricks-moving-files-from-s3-to-ec2-instance/

AWS install 

Anaconda 3 Version to install 
wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh

Other packages to install 
Tensorflow 
Keras

### Script Store
1. parse73.py

### Reference 

###### Auto-Encoder
1. https://blog.keras.io/building-autoencoders-in-keras.html - base inspiration
2. https://keras.io/getting-started/sequential-model-guide/ - further detail on sequential models  

###### T-SNE


###### AWS 
1. https://chrisalbon.com/software_engineering/cloud_computing/run_project_jupyter_on_amazon_ec2/ - Instance setup
