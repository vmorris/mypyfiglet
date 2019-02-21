FROM build:stage1

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY mypyfiglet.py ./

CMD ["python", "/usr/src/app/mypyfiglet.py"]

