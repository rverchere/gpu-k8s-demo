import gc
import os
import logging
import streamlit as st
import torch
from diffusers import StableDiffusion3Pipeline, StableDiffusionPipeline, DiffusionPipeline, EulerDiscreteScheduler, DPMSolverMultistepScheduler, AutoencoderKL
from huggingface_hub import login

logging.basicConfig(level=logging.INFO)

left_co, cent_co,right_co = st.columns(3)
with cent_co:
    st.image("img/logo.png")

chocolate_bar = st.slider('Nombre de barres de chocolat', 1, 5)
cooking_type = st.select_slider(
    "Type de cuisson",
    options=[
        "blanche",
        "claire",
        "standard",
        "brune",
        "cramée"
    ],
    value= "standard"
)

numbers = [ "zero", "une", "deux", "trois", "quatre", "cinq" ]

if 'login' not in st.session_state:
    st.session_state['login'] = 'true'
    login(token=os.environ["HUGGINGFACE_HUB_TOKEN"], add_to_git_credential=False)

left_co, cent_co,right_co = st.columns(3)
with cent_co:
    if torch.cuda.is_available():
        st.write("Utilisation de {count} GPUs".format(count=torch.cuda.device_count()))
    else:
        st.write("Pas de GPU, ça va pas marcher ^^")

    if st.button("Generate image",icon="🚀"):
        logging.info("Generating image")

        pipe = StableDiffusion3Pipeline.from_pretrained("stabilityai/stable-diffusion-3-medium-diffusers", torch_dtype=torch.float16)
        pipe = pipe.to("cuda")
        pipe.enable_attention_slicing()

        prompt = "Une photo d'un pain au chocolat avec une cuisson {cuisson}, avec {nombre} barres de chocolat à l'intérieur".format(nombre=numbers[chocolate_bar], cuisson=cooking_type)
        logging.info(prompt)

        image = pipe(
            prompt,
            negative_prompt="",
            num_inference_steps=28,
            height=704,
            width=704,
            guidance_scale=7.5,
        ).images[0]

        logging.info("Image generated")

if "image" in globals():
    st.image(image)
    logging.info("Image printed")
    logging.info(torch.cuda.memory_stats())
    logging.info(torch.cuda.memory_allocated())
    del pipe
    gc.collect()
    torch.cuda.empty_cache()
    torch.cuda.ipc_collect()
    logging.info(torch.cuda.memory_stats())
    logging.info(torch.cuda.memory_allocated())
