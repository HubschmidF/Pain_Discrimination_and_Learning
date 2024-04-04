#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#-----
# Model 10: Contingent trials, single learning rate

# Based on the functions and tutorial scripts available online at:
# https://hddm.readthedocs.io/en/latest/
#-----


# In[1]:


import pandas as pd
import numpy as np
import hddm
from scipy import stats
import seaborn as sns
import matplotlib.pyplot as plt
import pymc
import kabuki
sns.set(style="white")
get_ipython().run_line_magic('matplotlib', 'inline')
from tqdm import tqdm
import warnings
warnings.filterwarnings("ignore", category=np.VisibleDeprecationWarning)


# In[2]:


contdata = pd.read_csv("PDL_data_contingent.csv", sep = ";")
contdata.head()


# In[3]:


from kabuki.analyze import gelman_rubin

models = []
for i in range (3):
    RLCont = hddm.HDDMrl(contdata, depends_on = {'a': ['stim'], 't': ['stim'], 'v': ['stim']}, p_outlier = 0.05, bias = False)
    RLCont.find_starting_values()
    RLCont.sample(40000, burn = 30000, dbname = 'traces.db', db = 'pickle')
    models.append(RLCont)
    
np.max(list(gelman_rubin(models).values()))


# In[4]:


M10_concat = kabuki.utils.concat_models(models)


# In[5]:


M10_concat.plot_posteriors(['a'])


# In[6]:


M10_concat.plot_posteriors(['t'])


# In[7]:


M10_concat.plot_posteriors(['v'])


# In[8]:


M10_concat.plot_posteriors(['alpha'])


# In[9]:


M10_concat.print_stats()


# In[10]:


M10_traces = M10_concat.get_traces()


# In[11]:


M10_traces.to_csv(r'C:\Users\Hubsc\OneDrive\Desktop\RepositoryPRIMAS1\HDDM10_Draws.csv', index = False, header = True, sep = ';')


# In[ ]:


#-----

