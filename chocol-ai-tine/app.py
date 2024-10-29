import gc
import os
import logging
import streamlit as st
import torch
import time
from diffusers import StableDiffusion3Pipeline, StableDiffusionPipeline, DiffusionPipeline, EulerDiscreteScheduler, \
    DPMSolverMultistepScheduler, AutoencoderKL
from huggingface_hub import login

logging.basicConfig(level=logging.INFO)

# Fonction pour formater le temps écoulé
def format_time(seconds):
    return f"{seconds:.2f} secondes"

# Fonction pour formater la mémoire
def format_memory(bytes):
    return f"{bytes / 1024 / 1024:.2f} MB"

# Timer pour mesurer le temps total d'exécution
start_time_total = time.perf_counter()

left_co, cent_co, right_co = st.columns(3)
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
    value="standard"
)

numbers = ["zero", "une", "deux", "trois", "quatre", "cinq"]

if 'login' not in st.session_state:
    login_start_time = time.perf_counter()
    st.session_state['login'] = 'true'
    login(token=os.environ["HUGGINGFACE_HUB_TOKEN"], add_to_git_credential=False)
    login_time = time.perf_counter() - login_start_time
    st.write(f"⏱️ Temps de connexion: {format_time(login_time)}")

left_co, cent_co, right_co = st.columns(3)
with cent_co:
    if torch.cuda.is_available():
        st.write("Utilisation de {count} GPUs".format(count=torch.cuda.device_count()))
        st.write(f"💾 Mémoire CUDA initiale: {format_memory(torch.cuda.memory_allocated())}")
        logging.info(f"Memory stats initial: {torch.cuda.memory_stats()}")
    else:
        st.write("Pas de GPU, ça va pas marcher ^^")

    if st.button("Generate image", icon="🚀"):
        logging.info("Generating image")

        # Timer pour le chargement du modèle
        model_load_start = time.perf_counter()
        pipe = StableDiffusion3Pipeline.from_pretrained(
            "stabilityai/stable-diffusion-3-medium-diffusers",
            torch_dtype=torch.float16
        )
        pipe = pipe.to("cuda")
        pipe.enable_attention_slicing()
        model_load_time = time.perf_counter() - model_load_start
        st.write(f"⏱️ Temps de chargement du modèle: {format_time(model_load_time)}")
        st.write(f"💾 Mémoire CUDA après chargement: {format_memory(torch.cuda.memory_allocated())}")
        logging.info(f"Memory stats après chargement: {torch.cuda.memory_stats()}")

        prompt = "Une photo d'un pain au chocolat avec une cuisson {cuisson}, avec {nombre} barres de chocolat à l'intérieur".format(
            nombre=numbers[chocolate_bar],
            cuisson=cooking_type
        )
        logging.info(prompt)

        # Timer pour la génération d'image
        generation_start = time.perf_counter()
        image = pipe(
            prompt,
            negative_prompt="",
            num_inference_steps=28,
            height=704,
            width=704,
            guidance_scale=7.5,
        ).images[0]
        generation_time = time.perf_counter() - generation_start
        st.write(f"⏱️ Temps de génération de l'image: {format_time(generation_time)}")
        st.write(f"💾 Mémoire CUDA après génération: {format_memory(torch.cuda.memory_allocated())}")
        logging.info(f"Memory stats après génération: {torch.cuda.memory_stats()}")
        logging.info("Image generated")

if "image" in globals():
    st.image(image)
    logging.info("Image printed")

    # Log initial memory state
    logging.info(f"Memory stats avant nettoyage: {torch.cuda.memory_stats()}")
    logging.info(f"Memory allocated avant nettoyage: {torch.cuda.memory_allocated()}")

    # Timer pour le nettoyage mémoire
    cleanup_start = time.perf_counter()
    del pipe
    gc.collect()
    torch.cuda.empty_cache()
    torch.cuda.ipc_collect()
    cleanup_time = time.perf_counter() - cleanup_start

    # Log final memory state
    logging.info(f"Memory stats après nettoyage: {torch.cuda.memory_stats()}")
    logging.info(f"Memory allocated après nettoyage: {torch.cuda.memory_allocated()}")

    st.write(f"⏱️ Temps de nettoyage mémoire: {format_time(cleanup_time)}")
    st.write(f"💾 Mémoire CUDA finale: {format_memory(torch.cuda.memory_allocated())}")

# Temps total d'exécution
total_time = time.perf_counter() - start_time_total
st.write(f"⏱️ Temps total d'exécution: {format_time(total_time)}")