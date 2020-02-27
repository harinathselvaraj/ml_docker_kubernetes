# FROM python:3.7-alpine  -- using alphine will make python docker builds 50x times slower. https://pythonspeed.com/articles/alpine-docker-python/

# COPY . /app
# WORKDIR /app
# RUN apk update
# RUN apk add make automake gcc g++ subversion python3-dev
# # RUN apk add --update --no-cache py3-numpy py3-pandas
# RUN apk add py2-numpy@community py2-scipy@community py-pandas@edge
# RUN pip install -r requirements.txt

# CMD ["python","application.py"]

# Use slim version instead of alphine. https://towardsdatascience.com/how-to-build-slim-docker-images-fast-ecc246d7f4a7
FROM python:3.8.0-slim
RUN apt-get update \
&& apt-get install gcc -y \
&& apt-get clean
COPY requirements.txt /app/requirements.txt
WORKDIR app
RUN pip install --user -r requirements.txt
COPY . /app
ENTRYPOINT [ "python" ]
CMD [ "application.py" ]
