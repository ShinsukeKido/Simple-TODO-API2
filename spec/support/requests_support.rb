shared_examples_for 'Error response' do
  it 'HTTP ステータスコード 200 が返る' do
    get '/todos'
    expect(response.status).to eq 200
  end
end
shared_examples_for 'Error' do
  it 'todo が作成された数だけ JSON 出力される' do
    get '/todos'
    expect(jsons.count).to eq 3
  end
end
