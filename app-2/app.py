import gc
import os
import logging
import streamlit as st
import torch
from diffusers import StableDiffusion3Pipeline
from huggingface_hub import login

logging.basicConfig(level=logging.INFO)

left_co, cent_co, right_co = st.columns(3)
with cent_co:
    st.image("img/logo.png")

defenses_number = st.slider('Nombre de défenses', min_value=0, max_value=8, value= 2, step=2)
humor_type = st.select_slider(
    "Humeur",
    options=[
        "adorable",
        "très gentil",
        "fatigué",
        "heureux",
        "énervé",
        "très en colère"
    ],
    value= "heureux"
)

if 'login' not in st.session_state:
    st.session_state['login'] = 'true'
    login(token=os.environ["HUGGINGFACE_HUB_TOKEN"], add_to_git_credential=False)

left_co, cent_co, right_co = st.columns(3)
with cent_co:
    if torch.cuda.is_available():
        st.write("Utilisation de {count} GPUs".format(count=torch.cuda.device_count()))
    else:
        st.write("Pas de GPU, ça va pas marcher ^^")

    if st.button("Generate image", icon="🚀"):
        logging.info("Generating image")

        pipe = StableDiffusion3Pipeline.from_pretrained(
            "stabilityai/stable-diffusion-3-medium-diffusers",
            torch_dtype=torch.float16
        )
        pipe = pipe.to("cuda")
        pipe.enable_attention_slicing()

        prompt = "Photo de wild boar qui est {humor_type}, avec {defenses_number} grandes tusks sur son museau".format(
		    humor_type=humor_type,
			defenses_number=defenses_number
		)
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

    # Log initial memory state
    logging.info(f"Memory stats avant nettoyage: {torch.cuda.memory_stats()}")
    logging.info(f"Memory allocated avant nettoyage: {torch.cuda.memory_allocated()}")

    del pipe
    gc.collect()
    torch.cuda.empty_cache()
    torch.cuda.ipc_collect()

    # Log final memory state
    logging.info(f"Memory stats après nettoyage: {torch.cuda.memory_stats()}")
    logging.info(f"Memory allocated après nettoyage: {torch.cuda.memory_allocated()}")
