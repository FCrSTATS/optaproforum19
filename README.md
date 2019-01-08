# Dev-Log for Opta Pro Forum 2019 Presentation
## GAZING INTO LATENT SPACE TO FIND AN EDGE WITH POSSESSION CHAINS

### The Landscape
In August 2016, Marek Kwiatkowski laid out his vision for a new kind of analytics[ 1]. Encouraging the analytics community to zoom out from events on a unitary, singular, player-by-player level, thus allowing us to address the biggest so-far unexplored area of game - team dynamics of football, from a quantitative methodological perspective.

Marek’s assertion being that there is a lack of knowledge of team dynamics and without it the entirety of current quantitative player analysis is put in doubt. Marek refutes the claim that we must wait for greater access to tracking data in order to close this gap and that event data itself already contains a richness of dynamics information. At which point, Marek highlights the power of possession chains as fundamental building blocks of the game and the analysis of which could bring great understanding. Understanding that can be utilised in it’s own right but also to be fed back into basic research to provide additional context and richer analysis.

Since this article there has been a limited amount of public work published on the analysis of possession chains. There has not been a plethora of warriors rallied by Marek battle cries. The aim of my analysis is to contribute to Marek’s mission, establish some building blocks and show avenues to utility.

### Core Methods
Possession sequences for a large number of matches will be converted to chain maps which plots the path of the possession into a simple 128x128 single channel grayscale image (eventually possession paths will be shaded by sequential information in order to maintain the temporal dynamics context of the possession, not displayed below).

An auto-encoder neural network will be utilised to compress the chain maps input data into smaller representations and create latent vectors of each possession sequence. Similar latent vectors = similar possession sequences. The possession sequences are now available in high-dimensional data which can be visualised via T-SNE, mapped and gridded. Opposite is a depiction of the end result with one random possession displayed per grid, (reduced significantly in size to demonstrate intended methodologies).


### Dev-Log: November 

###### 27 Nov 
After receiving some create help via twitter I (others) managed to get the parsing of f73 data to a very quick speeds! This was acheived via [parse73.py](https://github.com/FCrSTATS/optaproforum19/blob/master/scripts/parse_f73.py) which is supported via it's utility scripts [parse_f73_utils.py](https://github.com/FCrSTATS/optaproforum19/blob/master/scripts/parse_f73_utils.py). In addition to this I parsed the f73 data again to create a database of matches for later reference via this [gameinfo_parse.py](https://github.com/FCrSTATS/optaproforum19/blob/master/scripts/gameinfo_parse.py). 

###### 28 Nov 
Completed a couple of data processing tasks to create some reference data to improve analysis later down the line. Firstly, a minutes played database to allowed per90 analysis later via [Minutes_Played_Process.R](https://github.com/FCrSTATS/optaproforum19/blob/master/scripts/Minutes_Played_Process.R). Secondly, a possession sequence database to help allocate credit to players involved [sequence_database_creation.R](https://github.com/FCrSTATS/optaproforum19/blob/master/scripts/sequence_database_creation.R).

### Dev-Log: December 1 - 14 

###### 1 Dec 
I spent a while completing the construction of the sequence plots, trying work out the best size, some alignment issues and how to represent the passing of time in the best way. I ended up creating a custom colour scale to represent time, this was constructured from [ R colour spectrum](http://research.stowers.org/mcm/efg/R/Color/Chart/ColorsChart1.jpg) which I had had limited exposure to prior. 

Via [image_creation_final.R](https://github.com/FCrSTATS/optaproforum19/blob/master/scripts/image_creation_final.R), this is what I ended up with, 128px by 128px squares, 5 randomly selected:

![alt_text](https://github.com/FCrSTATS/optaproforum19/blob/master/images/Unknown.png)

###### 6 Dec 
Got confirmation from Ryan than I can use different slide designs including this one: 
cid:image002.png@01D48D97.5FC5E590

###### 10 Dec
A key element of my analysis framework relied on the creation of an autoencoder - which can be displayed as such: 

![alt_text](https://cdn-images-1.medium.com/max/1600/1*44eDEuZBEsmG_TCAKRI3Kw@2x.png)

Spening a lot of time to repurpose the fanstastic [Building Autoencoders in Keras](https://blog.keras.io/building-autoencoders-in-keras.html) by [François Chollet](https://twitter.com/fchollet). Eventually deciding on the CNN as my model of choice. Having played around with the functional API I decided to go for the sequential API - lots of info in this [guide](https://keras.io/getting-started/sequential-model-guide/). The sequential was all that was really needed for my purposes as the functional API has a lot more feautures and power that I wasn't going to use. The sequential model also allowed me to access the encoded layer with less fuss (I am sure you can access it through the functional API but I couldn't get it to work). This was acheived by: 

```python
model2= model(model.input,model.get_layer("grab_that").output) 
latent_pred=model2.predict(data_test)
```

I got a basic encoder working, that had pretty poor predictions but ensured that I have a workflow that actually worked before I added more layers and features to the neural network to improve the predictions. 

### Dev-Log: December 15 - 31

###### 15 Dec 
Worked out how to copy files direct to s3 from terminal -> https://qiita.com/alokrawat050/items/56820afdb6968deec6a2

###### 17 Dec 
Good motivation having received some good feedback from Marek on the overall concept

###### 20 Dec 
Tried switching to Collabotory and loading files via Google Drive to overcome the issue of s3 access in AWS. Interesting to find out free GPU and TPU access with Collab but found that I ran out of memory very quickly and couldn't really run the analysis so I gave up and decided to revert to AWS the next day.

###### 21 Dec 
Trying to get the EC2 instance connected with my S3 storage in order to copy all of the image data across to the instance for processing. Solution is mainly this -> https://optimalbi.com/blog/2016/07/12/aws-tips-and-tricks-moving-files-from-s3-to-ec2-instance/

###### 24 Dec
Big progress

AWS install 

Anaconda 3 Version to install 
wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh

Other packages to install 
Tensorflow 
Keras

### Script Store
1. parse73.py

### Reference 

###### Literature Review
1. https://dtai.cs.kuleuven.be/events/MLSA18/papers/bransen_mlsa18.pdf - Measuring football players’ on-the-ball contributions from passes during games

###### Auto-Encoder
1. https://blog.keras.io/building-autoencoders-in-keras.html - base inspiration
2. https://keras.io/getting-started/sequential-model-guide/ - further detail on sequential models 
3. https://blogs.rstudio.com/tensorflow/posts/2019-01-08-getting-started-with-tf-probability/ - other options

###### T-SNE
1. https://distill.pub/2016/misread-tsne/ - Great guide
2. https://medium.com/@layog/i-dont-understand-t-sne-part-1-50f507acd4f9 - Deeper dive Part 1
3. https://medium.com/@layog/i-do-not-understand-t-sne-part-2-b2f997d177e3 - Deeper dive Part 2

###### AWS 
1. https://chrisalbon.com/software_engineering/cloud_computing/run_project_jupyter_on_amazon_ec2/ - Instance setup
