# Musescore_CalloutMeasure
MuseScore plugin to create a callout measure like the ones used in Handbell notation, showing which bells are needed. (Chimes are not supported yet.) Adapted from [CountNotes by jeetee](https://github.com/jeetee/MuseScore_CountNotes). Only tested on MuseScore 3.x. 

![image](https://user-images.githubusercontent.com/14922694/150149682-0a8e9690-51f7-471c-98ac-86b781700f45.png)

# Important Note
This plugin is still in development. Currently it counts all the notes used in the score, creates 12 empty measures at the beginning of the score, and inserts the notes used into them. You will need to edit the inserted measures manually to simulate an actual callout measure. (Can't find an API command for this at the moment)
**Please use this plugin with caution!** Recommended to make a backup of your score before using this, just in case. 

# Installation
Please see the [MuseScore handbook](https://musescore.org/en/handbook/3/plugins#installation) for installation. Make sure the plugin is enabled as described in the handbook. 

# Development Notes
As of now I am unable to find a way to fully automate the callout measure creation process, so some visual representations still need to be manually done as a workaround. 
The plugin does not separate chimes and bells yet - all notes will be counted together. 

# Step-by-step Tutorial
If your score has multiple parts (not only handbells) you should [separate them into different parts](https://musescore.org/en/handbook/3/parts) first before using the plugin. 

Go to the handbells part. 

![image](https://user-images.githubusercontent.com/14922694/150149420-e5bb5c84-9e2d-4a30-87c0-a7c462148c95.png)

Go to Plugins > Notes > CalloutMeasure

![image](https://user-images.githubusercontent.com/14922694/150150054-7c4dee88-aebe-45bc-9859-f98edbe3ca48.png)

The plugin will generate bars at the beginning of your piece and fill them in with the notes detected. 

![image](https://user-images.githubusercontent.com/14922694/150150550-fe2dbdbe-64e1-4733-8616-7cb4cb6bb5e4.png)

To remove the barlines in between, click on each barline and press Ctrl + Del (Cmd + Del on Mac). You have to do this individually for every barline. 

![image](https://user-images.githubusercontent.com/14922694/150150714-d7d24cc4-e90a-437a-9662-363866fab740.png)

![image](https://user-images.githubusercontent.com/14922694/150151117-863dc090-d090-44e9-9f3f-5a2ee95807dc.png)

You should end up with something like this after removing all the barlines. 

![image](https://user-images.githubusercontent.com/14922694/150151242-c2f8bd15-4d2f-41e2-b16f-8d90038b045a.png)

Select this long measure and right click on the measure > Measure Properties

![image](https://user-images.githubusercontent.com/14922694/150151400-b2efe7dd-f2fc-4e39-b8b0-868849c902e9.png)

Check both "stemless" boxes and "Exclude from measure count". Then click "Apply" and "OK". 

![image](https://user-images.githubusercontent.com/14922694/150151596-1cbbabc6-debd-4890-a648-77151eb5c127.png)

Select all the unwanted rests and press "V" to toggle them invisible. If you have a key signature you will also have to make it invisible in the callout measure. 

![image](https://user-images.githubusercontent.com/14922694/150151871-d19bfd93-cc27-46ab-9db7-f81f35744e53.png)

Delete any extra empty measures from the score. (Select measures > Ctrl + Delete or Cmd + Delete)

Make the time signature invisible as well. To make it appear again in the actual first measure of your score, drag and drop the time signature from palette to the measure you want it in. You may have to make invisible the extra time signature showing up to the right of your callout measure. 

![image](https://user-images.githubusercontent.com/14922694/150152472-de02e9e5-dead-45d5-849e-0e770cedc308.png)

Lastly, under "Breaks and Spacers" in your palette, find the "Section break" and drag and drop it on your callout measure. 

![image](https://user-images.githubusercontent.com/14922694/150152949-d8d28c96-efab-4697-b7de-5afa9108c2e9.png)

Your score is now ready with the callout measure. 

![image](https://user-images.githubusercontent.com/14922694/150153235-1e06ca5f-918f-4641-9c7a-64546557d0b6.png)

# Credits
[CountNotes by jeetee](https://github.com/jeetee/MuseScore_CountNotes)

[Callout measure guide](https://tommcarr.medium.com/using-musescore-for-handbell-music-c615ce993b2d)
