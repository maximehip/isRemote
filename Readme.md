# isRemote

isRemote that use machine learning (CoreML) to check if an object is an remote control.

## How ?

With Xcode I had trained a little machine learning model (FoundRemote. mlmodel). It uses this model to check if an object is a remote control. The model is trained with 28 different images. In the code I verify if confiance of pixel is >= 0.996.

